package com.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.entity.RegistrationDetail;

@Repository
public interface MyRepository extends 
        JpaRepository<RegistrationDetail, Integer> {

}
