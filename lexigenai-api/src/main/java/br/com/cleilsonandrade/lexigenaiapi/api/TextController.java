package br.com.cleilsonandrade.lexigenaiapi.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.theokanning.openai.completion.CompletionRequest;
import com.theokanning.openai.service.OpenAiService;

import br.com.cleilsonandrade.lexigenaiapi.domain.model.TextGenerate;

@RestController
@RequestMapping("/texts")
public class TextController {
  @Value("${openai.token}")
  private String TOKEN_OPENAI;

  @PostMapping
  public ResponseEntity<?> generate(@RequestBody TextGenerate textGenerate) {
    try {
      OpenAiService service = new OpenAiService(TOKEN_OPENAI);
      CompletionRequest completionRequest = CompletionRequest.builder()
          .model("text-davinci-003")
          .prompt(textGenerate.getText())
          .maxTokens(4000)
          .temperature(textGenerate.getTemperature())
          .build();
      return ResponseEntity.ok(service.createCompletion(completionRequest).getChoices());
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }
}
