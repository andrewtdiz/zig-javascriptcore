pub const c = @cImport({
    @cInclude("JavaScriptCore/JavaScriptCore.h");
});

pub const JS = c;
