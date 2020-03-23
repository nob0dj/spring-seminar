package com.kh.springboot.menu.model.vo;

import java.io.Serializable;

import com.sun.xml.internal.ws.developer.Serialization;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Menu implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int id;
	private String restaurant;
	private String name;
	private int price;
	private String type;
	private String taste;
	
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
}
