package br.com.cleilsonandrade.lexigenaiapi.domain.model;

import lombok.Data;

@Data
public class ImageGenerate {
  private String text;
  private Integer number = 1;
  private String size = "1024x1024";
}
