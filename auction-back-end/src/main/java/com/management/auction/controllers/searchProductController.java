package com.management.auction.controllers;

import com.management.auction.services.searchProductService;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/search")
public class searchProductController {

    protected final searchProductService searchs;

    public searchProductController(searchProductService searchs) {
        this.searchs = searchs;
    }

    @GetMapping("/{productname}")
    public ResponseEntity<SuccessResponse> getExpireAbout(@PathVariable String productname) {
        return ControllerUtil.returnSuccess(searchs.findByName(productname), HttpStatus.OK);
    }
}
