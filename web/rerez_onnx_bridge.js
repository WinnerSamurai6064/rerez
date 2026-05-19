(function () {
  const MODEL_URL = 'assets/assets/models/real_esrgan_general_x4v3.onnx';

  let sessionPromise = null;

  window.rerezOnnxReady = function () {
    return Boolean(window.ort);
  };

  window.rerezRunRealEsrgan = async function (imageBase64, options = {}) {
    try {
      if (!window.ort) {
        return {
          ok: false,
          error: 'ONNX Runtime Web is not loaded.',
        };
      }

      const session = await getSession();

      const maxInputSize = Number(options.maxInputSize || 256);
      const image = await decodeBase64Image(imageBase64);
      const prepared = prepareImageForModel(image, maxInputSize);

      const inputTensor = new ort.Tensor(
        'float32',
        prepared.tensorData,
        [1, 3, prepared.height, prepared.width],
      );

      const inputName = session.inputNames[0];

      const feeds = {
        [inputName]: inputTensor,
      };

      const results = await session.run(feeds);
      const outputName = session.outputNames[0];
      const outputTensor = results[outputName];

      const outputCanvas = tensorToCanvas(outputTensor);
      const blob = await canvasToBlob(outputCanvas, options.format || 'PNG');
      const resultBase64 = await blobToBase64(blob);

      return {
        ok: true,
        imageBase64: resultBase64,
        width: outputCanvas.width,
        height: outputCanvas.height,
        method: 'Real-ESRGAN',
        scale: 'x4',
        format: options.format || 'PNG',
      };
    } catch (error) {
      console.error('[rerez_onnx_error]', error);

      return {
        ok: false,
        error: error && error.message ? error.message : 'Real-ESRGAN failed.',
      };
    }
  };

  async function getSession() {
    if (!sessionPromise) {
      sessionPromise = ort.InferenceSession.create(MODEL_URL, {
        executionProviders: ['wasm'],
        graphOptimizationLevel: 'all',
      });
    }

    return sessionPromise;
  }

  async function decodeBase64Image(imageBase64) {
    const cleanBase64 = String(imageBase64).includes(',')
      ? String(imageBase64).split(',').pop()
      : String(imageBase64);

    const binary = atob(cleanBase64);
    const bytes = new Uint8Array(binary.length);

    for (let i = 0; i < binary.length; i += 1) {
      bytes[i] = binary.charCodeAt(i);
    }

    const blob = new Blob([bytes], {
      type: 'image/png',
    });

    const bitmap = await createImageBitmap(blob);

    const canvas = document.createElement('canvas');
    canvas.width = bitmap.width;
    canvas.height = bitmap.height;

    const ctx = canvas.getContext('2d', {
      willReadFrequently: true,
    });

    ctx.drawImage(bitmap, 0, 0);

    return canvas;
  }

  function prepareImageForModel(sourceCanvas, maxInputSize) {
    const scaleDown = Math.min(
      1,
      maxInputSize / Math.max(sourceCanvas.width, sourceCanvas.height),
    );

    const width = Math.max(1, Math.round(sourceCanvas.width * scaleDown));
    const height = Math.max(1, Math.round(sourceCanvas.height * scaleDown));

    const canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d', {
      willReadFrequently: true,
    });

    ctx.imageSmoothingEnabled = true;
    ctx.imageSmoothingQuality = 'high';
    ctx.drawImage(sourceCanvas, 0, 0, width, height);

    const imageData = ctx.getImageData(0, 0, width, height);
    const pixels = imageData.data;
    const tensorData = new Float32Array(1 * 3 * width * height);

    const planeSize = width * height;

    for (let i = 0; i < planeSize; i += 1) {
      const pixelIndex = i * 4;

      tensorData[i] = pixels[pixelIndex] / 255;
      tensorData[planeSize + i] = pixels[pixelIndex + 1] / 255;
      tensorData[planeSize * 2 + i] = pixels[pixelIndex + 2] / 255;
    }

    return {
      width,
      height,
      tensorData,
    };
  }

  function tensorToCanvas(tensor) {
    const dims = tensor.dims;

    if (!Array.isArray(dims) || dims.length !== 4) {
      throw new Error(`Unexpected output tensor shape: ${dims.join('x')}`);
    }

    const channels = dims[1];
    const height = dims[2];
    const width = dims[3];

    if (channels < 3) {
      throw new Error(`Unexpected output channel count: ${channels}`);
    }

    const data = tensor.data;
    const planeSize = width * height;

    const canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d', {
      willReadFrequently: true,
    });

    const imageData = ctx.createImageData(width, height);
    const pixels = imageData.data;

    for (let i = 0; i < planeSize; i += 1) {
      const pixelIndex = i * 4;

      pixels[pixelIndex] = clampByte(data[i] * 255);
      pixels[pixelIndex + 1] = clampByte(data[planeSize + i] * 255);
      pixels[pixelIndex + 2] = clampByte(data[planeSize * 2 + i] * 255);
      pixels[pixelIndex + 3] = 255;
    }

    ctx.putImageData(imageData, 0, 0);

    return canvas;
  }

  function clampByte(value) {
    return Math.max(0, Math.min(255, Math.round(value)));
  }

  function canvasToBlob(canvas, format) {
    const mimeType = String(format).toUpperCase() === 'JPG'
      ? 'image/jpeg'
      : 'image/png';

    const quality = mimeType === 'image/jpeg' ? 0.92 : undefined;

    return new Promise((resolve, reject) => {
      canvas.toBlob(
        (blob) => {
          if (!blob) {
            reject(new Error('Could not encode output image.'));
            return;
          }

          resolve(blob);
        },
        mimeType,
        quality,
      );
    });
  }

  function blobToBase64(blob) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();

      reader.onloadend = () => {
        const result = String(reader.result || '');
        resolve(result.split(',').pop() || '');
      };

      reader.onerror = () => {
        reject(new Error('Could not read output image.'));
      };

      reader.readAsDataURL(blob);
    });
  }
})();
