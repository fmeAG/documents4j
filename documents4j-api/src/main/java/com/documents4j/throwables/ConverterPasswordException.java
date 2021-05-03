package com.documents4j.throwables;

/**
 * Thrown if the source file that was provided for a conversion has a password protection and cannot be opened.
 *
 */
public class ConverterPasswordException extends ConverterException {

    public ConverterPasswordException(String message) {
        super(message);
    }

    public ConverterPasswordException(String message, Throwable cause) {
        super(message, cause);
    }
}
