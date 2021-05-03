package com.documents4j.conversion.msoffice;

import com.documents4j.api.DocumentType;
import com.documents4j.conversion.ExternalConverterScriptResult;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.zeroturnaround.exec.StartedProcess;

import java.io.File;
import java.util.Arrays;
import java.util.Collection;

import static com.documents4j.conversion.msoffice.MicrosoftPowerpointPresentation.*;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class MicrosoftPowerpointConversionPasswordTest extends AbstractMicrosoftOfficeConversionTest {

    public MicrosoftPowerpointConversionPasswordTest(Document valid,
                                                     Document corrupt,
                                                     Document inexistent,
                                                     DocumentType sourceDocumentType,
                                                     DocumentType targetDocumentType,
                                                     String targetFileNameSuffix,
                                                     boolean supportsLockedConversion) {
        super(new DocumentTypeProvider(valid, corrupt, inexistent, sourceDocumentType, targetDocumentType, targetFileNameSuffix, supportsLockedConversion));
    }

    @Parameterized.Parameters
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][]{
               {PPT_PASSWORD, PPT_CORRUPT, PPT_INEXISTENT, DocumentType.PPT, DocumentType.PPTX, "pptx", false}

        });
    }

    @BeforeClass
    public static void setUpConverter() throws Exception {
        AbstractMicrosoftOfficeConversionTest.setUp(MicrosoftPowerpointBridge.class, MicrosoftPowerpointScript.ASSERTION, MicrosoftPowerpointScript.SHUTDOWN);
    }

    private void testConversionPassword(File source, File target) throws Exception {
        assertTrue(source.exists());
        assertFalse(target.exists());
        StartedProcess conversion = getOfficeBridge().doStartConversion(source, getSourceDocumentType(), target, getTargetDocumentType());
        int exitValue = conversion.getFuture().get().getExitValue();
        assertEquals(
                ExternalConverterScriptResult.PASSWORD_PROTECTED.getExitValue().intValue(),
                exitValue);
        assertFalse(target.exists());
    }

    @Test(timeout = DEFAULT_CONVERSION_TIMEOUT)
    public void testConversionPassword() throws Exception {

         testConversionPassword(validSourceFile(true), makeTarget(true));

    }

}
