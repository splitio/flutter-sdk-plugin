package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;
import org.mockito.MockitoAnnotations;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class ArgumentParserImplTest {

    private ArgumentParserImpl mArgumentParser;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        mArgumentParser = new ArgumentParserImpl();
    }

    @Test
    public void testGetStringArgument() {
        Map<String, Object> map = new HashMap<>();
        map.put("apiKey", "api-key");
        map.put("matchingKey", false);
        String apiKey = mArgumentParser.getStringArgument("apiKey", map);

        assertEquals("api-key", apiKey);
    }

    @Test
    public void testGetStringArgumentFailure() {
        Map<String, Object> map = new HashMap<>();
        map.put("matchingKey", false);
        String matchingKey = mArgumentParser.getStringArgument("matchingKey", map);

        assertNull(matchingKey);
    }

    @Test
    public void testGetMapArgument() {
        Map<String, Object> map = new HashMap<>();
        map.put("apiKey", "api-key");
        map.put("matchingKey", false);

        Map<String, Object> arguments = new HashMap<>();
        arguments.put("mapArgument", map);
        Map<String, Object> mapArgument = mArgumentParser.getMapArgument("mapArgument", arguments);

        assertEquals(map, mapArgument);
    }

    @Test
    public void testGetMapArgumentFailure() {
        Map<String, Object> map = new HashMap<>();
        map.put("apiKey", "api-key");
        Map<String, Object> mapArgument = mArgumentParser.getMapArgument("mapArgument", map);

        assertEquals(Collections.emptyMap(), mapArgument);
    }

    @Test
    public void testGetBooleanArgument() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("trueArgument", true);
        arguments.put("falseArgument", false);
        boolean trueArgument = mArgumentParser.getBooleanArgument("trueArgument", arguments);
        boolean falseArgument = mArgumentParser.getBooleanArgument("falseArgument", arguments);

        assertTrue(trueArgument);
        assertFalse(falseArgument);
    }

    @Test
    public void testGetBooleanFailure() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("trueArgument", "true");

        boolean trueArgument = mArgumentParser.getBooleanArgument("trueArgument", arguments);

        assertFalse(trueArgument);
    }
}
