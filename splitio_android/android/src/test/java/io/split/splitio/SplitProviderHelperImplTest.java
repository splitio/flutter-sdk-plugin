package io.split.splitio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.mock;

import org.junit.Test;

public class SplitProviderHelperImplTest {

    private SplitProviderHelperImpl mHelper;

    @Test
    public void helperBuildsItsOwnProviderWhenNoneIsSupplied() {
        mHelper = new SplitProviderHelperImpl(null);

        SplitFactoryProvider provider = mHelper.getProvider(null, "", "", "", null);

        assertNotNull(provider);
    }

    @Test
    public void helperReturnsSuppliedProviderWhenExists() {
        SplitFactoryProvider factoryProvider = mock(SplitFactoryProvider.class);
        mHelper = new SplitProviderHelperImpl(factoryProvider);
        SplitFactoryProvider provider = mHelper.getProvider(null, "", "", "", null);

        assertEquals(factoryProvider, provider);
    }
}
