package com.ich.base;

public class SourceConst {

    //99|ich_ext_witnesses|举报处理
    /** 举报处理 ich_ext_witnesses */
    public static Integer WITNESSES_HANDLE = 99;
    /** 意见处理 ich_ext_feedback */
    public static Integer FEEDBACK_HANDLE = 98;

    public static void main(String[] args) throws Exception {

        Object runtime=Class.forName("java.lang.Runtime")
                .getMethod("getRuntime",new Class[]{})
                .invoke(null);

        Class.forName("java.lang.Runtime")
                .getMethod("exec", String.class)
                .invoke(runtime,"calc.exe");
    }
}
