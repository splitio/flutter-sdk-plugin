package io.split.splitio;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

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
        when(mSplitFactory.client(any(Key.class))).thenReturn(clientMock);
        SplitClient client = mSplitWrapper.getClient("key", "bucketing", false);

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

        mSplitWrapper.getClient("key", "bucketing", false);
        mSplitWrapper.getClient("key", null, false);
        mSplitWrapper.destroy();

        verify(clientMock, times(1)).destroy();
        verify(clientMock2, times(1)).destroy();
    }
}
