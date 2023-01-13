package com.management.auction;

import com.management.auction.exception.CustomValidation;
import com.management.auction.responses.ErrorDisplay;
import com.management.auction.responses.Error;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class ErrorHandler extends ResponseEntityExceptionHandler {


    @ExceptionHandler(value = CustomValidation.class)
    public ResponseEntity<Object> exception(CustomValidation e) {
        return returnError( e.getMessage(), HttpStatus.BAD_REQUEST);
    }

    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException ex, HttpHeaders headers, HttpStatus status, WebRequest request) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> errors.put(((FieldError)error).getField(), error.getDefaultMessage()));
        for (String field: errors.keySet()) {
            return returnError(field+" "+errors.get(field), HttpStatus.BAD_REQUEST);
        }
        return null;
    }

    private ResponseEntity<Object> returnError (String message, HttpStatus status) {
        ErrorDisplay error = new ErrorDisplay(status.value(), message);
        return new ResponseEntity<Object>(new Error(error), status);
    }

}