package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.RegistrationDetail;
import com.repository.MyRepository;

@Service
public class RegistrationService {

	  @Autowired
	  private MyRepository repository;
	  
	  public RegistrationDetail insertData(RegistrationDetail detail) {
		   System.out.println("Data Inserted!");
		   return  repository.save(detail);
		    
	  }
	  
	  public List<RegistrationDetail> getData(){
		      List<RegistrationDetail> all = repository.findAll();
		     all.forEach(System.out::println);
		     return all;
	  }
}
