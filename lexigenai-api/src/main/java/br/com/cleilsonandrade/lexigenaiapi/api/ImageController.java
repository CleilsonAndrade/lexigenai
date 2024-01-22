package br.com.cleilsonandrade.lexigenaiapi.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.theokanning.openai.image.CreateImageRequest;
import com.theokanning.openai.image.ImageResult;
import com.theokanning.openai.service.OpenAiService;

import br.com.cleilsonandrade.lexigenaiapi.domain.model.ImageGenerate;

@RestController
@RequestMapping("/images")
public class ImageController {

  @Value("${openai.token}")
  private String TOKEN_OPENAI;

  @PostMapping
  public ResponseEntity<?> generate(@RequestBody ImageGenerate imageGenerate) {
    try {
      OpenAiService service = new OpenAiService(TOKEN_OPENAI);

      ImageResult imageResult = service.createImage(
          CreateImageRequest.builder()
              .prompt(imageGenerate.getText())
              .n(imageGenerate.getNumber())
              .size(imageGenerate.getSize())
              .build());

      return ResponseEntity.ok(imageResult.getData());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }
}
