{% import 'template_utils.ha' as template_utils with context %}

// XCB
export type xcb_connection_t = nullable *void;
export type xcb_window_t = u32;
export type xcb_visualid_t = u32;
export type zx_handle_t = u32;

// Android (somehow already defined)
// export type ANativeWindow = nullable *void;
// export type AHardwareBuffer = nullable *void;

// iOS / macOS (some are somehow already defined)
// export type CAMetalLayer = nullable *void;
export type GgpFrameToken = u32;
export type GgpStreamDescriptor = u32;

// DirectFB
export type IDirectFB = nullable *void;
export type IDirectFBSurface = nullable *void;

// xlib (_xrandr)
export type Display = nullable *void;
export type RROutput = u32;
export type Window = u32;
export type VisualID = u32;

// Win32
export type BOOL = i32;
export type DWORD = u32;
export type LPVOID = nullable *void;
export type HANDLE = nullable *void;
export type HMONITOR = nullable *void;
export type WCHAR = u16;
export type LPCWSTR = *const void; // hare doesn't have wide chars
export type HINSTANCE = nullable *void;
export type HWND = nullable *void;
export type SECURITY_ATTRIBUTES = struct {
    nLength: DWORD,
    lpSecurityDescriptor: LPVOID,
    bInheritHandle: BOOL,
};

// Wayland
export type wl_display = nullable *void;
export type wl_surface = nullable *void;

// Mir
export type MirConnection = nullable *void;
export type MirSurface = nullable *void;

export fn VK_MAKE_VERSION(major: uint, minor: uint, patch: uint) uint = {
	return (major << 22) | (minor << 12) | patch;
};
export fn VK_MAKE_API_VERSION(variant: uint, major: uint, minor: uint, patch: uint) uint = {
	return (variant << 29) | (major << 22) | (minor << 12) | patch;
};

export const VK_API_VERSION_1_0: uint = (0 << 29) | (1 << 22) | (0 << 12) | 0;
export const VK_API_VERSION_1_1: uint = (0 << 29) | (1 << 22) | (1 << 12) | 0;
export const VK_API_VERSION_1_2: uint = (0 << 29) | (1 << 22) | (2 << 12) | 0;
export const VK_API_VERSION_1_3: uint = (0 << 29) | (1 << 22) | (3 << 12) | 0;

export fn VK_VERSION_MAJOR(version: uint) uint = {
	return version >> 22;
};
export fn VK_VERSION_MINOR(version: uint) uint = {
	return (version >> 12) & 0x3ff;
};
export fn VK_VERSION_PATCH(version: uint) uint = {
	return version & 0xfff;
};

{% for type in feature_set.types %}
{% if type.alias %}
export type {{ type.name }} = {{ type.alias }};
{% elif type.category == 'basetype' %}
export type {{ type.name }} = {{ type.type|type }};
{% elif type.category == 'handle' %}
export type {{ type.name }} = nullable *void;
{% elif type.category == 'enum' %}
{% set members = type.enums_for(feature_set) %}
{% if members %}
{% call template_utils.protect(type) %}
export type {{ type.name }} = enum u{{ type.bitwidth or 32 }} {
{% for member in members %}
{% if not member.alias %}
	{{ member.name }} = {{ member.value }},
{% else %}
	{{ member.name }} = {{ member.alias|alias_to_value(type) }},
{% endif %}
{% endfor %}
};
{% endcall %}
export fn Str{{ type.name }}(value: {{ type.name }}) str = {
	switch (value) {
	{% for member in members %}
	case {{ type.name }}::{{ member.name }} =>
		return "{{ member.name }}";
	{% endfor %}
	};
};
{% endif %}
{% elif type.category in ('struct', 'union') %}
{% call template_utils.protect(type) %}
export type {{ type.name }} = {{ type.category }} {
{% for member in type.members %}
	{{ member.name|identifier }}: {% if member.enum %}[{{ member.enum }}]{% endif %}{{ member.type|type }},
{% endfor %}
};
{% endcall %}
{% elif type.category == 'bitmask' %}
export type {{ type.name }} = {{ type.type }};
{% elif type.category == 'funcpointer' %}
export type {{ type.name }} = nullable *fn(
{% for parameter in type.parameters %}
	{{ parameter.name|identifier }}: {{ parameter.type|type }},
{% endfor %}
) {{ type.ret|type }};
{% endif %}
{% endfor %}
