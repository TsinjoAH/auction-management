package utils;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;

public class Base64ToFile {

    public static void convert(String base64Str, String path) throws IOException {
        byte[] data = Base64.getDecoder().decode(base64Str);
        try (FileOutputStream stream = new FileOutputStream(path)) {
            stream.write(data);
        }
    }
}