package com.kh.spring.stomp.model.vo;

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
public class Notice {
	private Long id;
	private String from;
	private String to;
	private String msg;
	private long time;
}
