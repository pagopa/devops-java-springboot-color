package it.pagopa.devops.springbootshowcase;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/app")
public class AppController {

    @Value("${MY_APP_COLOR:}")
    private String myAppColor;

    @GetMapping(path = "", produces=MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> mainApp()
    {
        return root();
    }

    @GetMapping(path = "/", produces=MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> root()
    {
        HashMap<String, String> map = new HashMap<>();
        map.put("root", "ok");
        return map;
    }

    @GetMapping(path = "/envs", produces=MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> envs()
    {
        HashMap<String, String> map = new HashMap<>();
        System.getenv().forEach((k, v) -> {
            map.put(k, v);
        });
        return map;
    }

    @GetMapping(path = "/color", produces=MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> color()
    {
        HashMap<String, String> map = new HashMap<>();
        map.put("color", myAppColor);
        return map;
    }
}
