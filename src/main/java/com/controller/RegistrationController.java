package com.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.entity.RegistrationDetail;
import com.service.RegistrationService;

@Controller
//@RequestMapping("/commonPage")
public class RegistrationController {
	
	@Autowired
	private RegistrationService service;

	@ModelAttribute
	public void common(Model model) {
		model.addAttribute("pageheader", "Welcome to Spring World with Prashant!");
		model.addAttribute("page", "RegistrationPage");
	}
	// http://localhost:8080/register
	@RequestMapping("/register")
	public String register() {
		// String value=null;
		 //System.out.println(value.equals("logical name"));
		 
		 return "registration";
	}
	
	@RequestMapping(path="/printDetail",method = RequestMethod.POST)
	public String detail(
			@ModelAttribute RegistrationDetail detail
			              ) {
             // String username = detail.getUsername();
              //int data=Integer.parseInt("abc");
		// model.addAttribute("detail", detail);
		  service.insertData(detail);
		
		 return "status";
	}
	
	
	@RequestMapping("/fetch")
	public String printData(Model model) {
		 
		    List<RegistrationDetail> data = 
		    		service.getData();
		    
		    model.addAttribute("data", data);
		    
		    return "print";
		
	}
	
	
	
	/*
	@ExceptionHandler(value = NullPointerException.class)
	public String getNullExceptionHandler(Model model) {
		model.addAttribute("msg", "Because of No value passed in the string");
		     return "errorPage";
	}
	
	@ExceptionHandler(value = NumberFormatException.class)
	public String getNumberFormatExceptionHandler(Model model) {
		model.addAttribute("msg", "Because of wrong input convertion to int type");
		     return "errorPage";
	}
	*/
	
	@ExceptionHandler(value = Exception.class)
	public String getExceptionHandler(Model model) {
		model.addAttribute("msg", "Check your controller method based on URL");
		     return "errorPage";
	}
	
}
