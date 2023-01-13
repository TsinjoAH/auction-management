package com.management.auction;


import custom.springutils.exception.CustomException;
import custom.springutils.util.ErrorDisplay;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ErrorHandler {

    @ExceptionHandler(value = CustomException.class)
    public ResponseEntity<Object> customError(CustomException e) {
        return new ResponseEntity<>( new ErrorDisplay(HttpStatus.BAD_REQUEST, e), HttpStatus.BAD_REQUEST);
    }

}