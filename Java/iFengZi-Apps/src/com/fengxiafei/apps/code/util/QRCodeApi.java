package com.fengxiafei.apps.code.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.google.zxing.qrcode.encoder.ByteMatrix;
import com.google.zxing.qrcode.encoder.Encoder;
import com.google.zxing.qrcode.encoder.QRCode;
import java.util.Hashtable;

public final class QRCodeApi {
	@SuppressWarnings("unused")
	private static final int QUIET_ZONE_SIZE = 4;

	public static BitMatrix encode(String contents, BarcodeFormat format,
			int width, int height) throws WriterException {
		return encode(contents, format, width, height, null);
	}

	@SuppressWarnings("rawtypes")
	public static BitMatrix encode(String contents, BarcodeFormat format,
			int width, int height, Hashtable hints) throws WriterException {
		QRCode code = enQrcode(contents, format, hints);

		return renderResult(code, width, height);
	}

	public static BitMatrix encodeMultiple(String contents,
			BarcodeFormat format, int multiple) throws WriterException {
		return encodeMultiple(contents, format, multiple, null);
	}

	@SuppressWarnings("rawtypes")
	public static BitMatrix encodeMultiple(String contents,
			BarcodeFormat format, int multiple, Hashtable hints)
			throws WriterException {
		QRCode code = enQrcode(contents, format, hints);

		return renderResultMultiple(code, multiple);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static QRCode enQrcode(String contents, BarcodeFormat format,
			Hashtable hints) throws WriterException {
		if (contents.length() == 0) {
			throw new IllegalArgumentException("Found empty contents");
		}

		if (format != BarcodeFormat.QR_CODE) {
			throw new IllegalArgumentException(
					"Can only encode QR_CODE, but got " + format);
		}

		ErrorCorrectionLevel errorCorrectionLevel = ErrorCorrectionLevel.M;

		if (hints != null) {
			ErrorCorrectionLevel requestedECLevel = (ErrorCorrectionLevel) hints
					.get(EncodeHintType.ERROR_CORRECTION);

			if (requestedECLevel != null) {
				errorCorrectionLevel = requestedECLevel;
			}
		}

		QRCode code = new QRCode();
		Encoder.encode(contents, errorCorrectionLevel, hints, code);

		return code;
	}

	private static BitMatrix renderResult(QRCode code, int width, int height) {
		ByteMatrix input = code.getMatrix();
		if (input == null) {
			throw new IllegalStateException();
		}
		int inputWidth = input.getWidth();
		int inputHeight = input.getHeight();
		int qrWidth = inputWidth + 8;
		int qrHeight = inputHeight + 8;
		int outputWidth = Math.max(width, qrWidth);
		int outputHeight = Math.max(height, qrHeight);

		int multiple = Math.min((outputWidth - 8) / inputWidth,
				(outputHeight - 8) / inputHeight);

		int leftPadding = (outputWidth - (inputWidth * multiple)) / 2;
		int topPadding = (outputHeight - (inputHeight * multiple)) / 2;

		BitMatrix output = new BitMatrix(outputWidth, outputHeight);

		int inputY = 0;
		for (int outputY = topPadding; inputY < inputHeight; outputY += multiple) {
			int inputX = 0;
			for (int outputX = leftPadding; inputX < inputWidth; outputX += multiple) {
				if (input.get(inputX, inputY) == 1)
					output.setRegion(outputX, outputY, multiple, multiple);
				++inputX;
			}
			++inputY;
		}

		return output;
	}

	private static BitMatrix renderResultMultiple(QRCode code, int multiple) {
		ByteMatrix input = code.getMatrix();

		if (input == null) {
			throw new IllegalStateException();
		}

		if (multiple < 1) {
			throw new IllegalArgumentException("multiple < 1");
		}

		int inputWidth = input.getWidth();
		int inputHeight = input.getHeight();

		int outputWidth = inputWidth * multiple + 8;
		int outputHeight = inputHeight * multiple + 8;

		int leftPadding = 4;
		int topPadding = 4;

		BitMatrix output = new BitMatrix(outputWidth, outputHeight);

		int inputY = 0;
		for (int outputY = topPadding; inputY < inputHeight; outputY += multiple) {
			int inputX = 0;
			for (int outputX = leftPadding; inputX < inputWidth; outputX += multiple) {
				if (input.get(inputX, inputY) == 1)
					output.setRegion(outputX, outputY, multiple, multiple);
				++inputX;
			}
			++inputY;
		}

		return output;
	}
}
