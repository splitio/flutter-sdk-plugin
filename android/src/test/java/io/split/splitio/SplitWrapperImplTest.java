package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.Collections;

import io.split.android.client.SplitClient;
import io.split.android.client.SplitFactory;
import io.split.android.client.api.Key;

public class SplitWrapperImplTest {

    private SplitWrapperImpl mSplitWrapper;

    @Mock
    private SplitFactoryProvider mSplitFactoryProvider;
    @Mock
    private SplitFactory mSplitFactory;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        when(mSplitFactoryProvider.getSplitFactory()).thenReturn(mSplitFactory);

        mSplitWrapper = new SplitWrapperImpl(mSplitFactoryProvider);
    }

    @Test
    public void testGetClient() {
        SplitClient clientMock = mock(SplitClient.class);
        when(mSplitFactory.client("key", "bucketing")).thenReturn(clientMock);
        SplitClient client = mSplitWrapper.getClient("key", "bucketing");

        assertEquals(clientMock, client);
    }

    @Test
    public void testDestroy() {
        SplitClient clientMock = mock(SplitClient.class);
        SplitClient clientMock2 = mock(SplitClient.class);

        Key key = new Key("key", "bucketing");
        Key key2 = new Key("key");
        when(mSplitFactory.client(key)).thenReturn(clientMock);
        when(mSplitFactory.client(key2)).thenReturn(clientMock2);

        mSplitWrapper.getClient("key", "bucketing");
        mSplitWrapper.getClient("key", null);
        mSplitWrapper.destroy();

        verify(clientMock, times(1)).destroy();
        verify(clientMock2, times(1)).destroy();
    }

    @Test
    public void testGetTreatment() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.getTreatment("key", null, "split-name", Collections.singletonMap("age", 50));

        verify(clientMock).getTreatment("split-name", Collections.singletonMap("age", 50));
    }

    @Test
    public void testGetTreatments() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.getTreatments("key", null, Arrays.asList("split1", "split2"), Collections.singletonMap("age", 50));

        verify(clientMock).getTreatments(Arrays.asList("split1", "split2"), Collections.singletonMap("age", 50));
    }

    @Test
    public void testGetTreatmentWithConfig() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.getTreatmentWithConfig("key", null, "split-name", Collections.singletonMap("age", 50));

        verify(clientMock).getTreatmentWithConfig("split-name", Collections.singletonMap("age", 50));
    }

    @Test
    public void testGetTreatmentsWithConfig() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.getTreatmentsWithConfig("key", null, Arrays.asList("split1", "split2"), Collections.singletonMap("age", 50));

        verify(clientMock).getTreatmentsWithConfig(Arrays.asList("split1", "split2"), Collections.singletonMap("age", 50));
    }

    @Test
    public void testTrack() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.track("key", null, "my_event", "account", 25.20, Collections.singletonMap("age", 50));

        verify(clientMock).track("account", "my_event", 25.20, Collections.singletonMap("age", 50));
    }

    @Test
    public void testTrackWithoutTrafficType() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.track("key", null, "my_event", null, 25.20, Collections.singletonMap("age", 50));

        verify(clientMock).track("my_event", 25.20, Collections.singletonMap("age", 50));
    }

    @Test
    public void testTrackWithoutTrafficTypeNorValue() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.track("key", null, "my_event", null, null, Collections.singletonMap("age", 50));

        verify(clientMock).track("my_event", Collections.singletonMap("age", 50));
    }

    @Test
    public void testTrackWithoutValue() {
        SplitClient clientMock = mock(SplitClient.class);

        when(mSplitFactory.client("key", null)).thenReturn(clientMock);

        mSplitWrapper.track("key", null, "my_event", "account", null, Collections.singletonMap("age", 50));

        verify(clientMock).track("account", "my_event", Collections.singletonMap("age", 50));
    }
}
