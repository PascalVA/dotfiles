return {
  "ovk/endec.nvim",
  event = "VeryLazy",
  opts = {
    keymaps = {
      defaults = false,

      -- Decode Base64 in-place (normal mode)
      decode_base64_inplace = "gyb",

      -- Decode Base64 in-place (visual mode)
      vdecode_base64_inplace = "gyb",

      -- Decode Base64 in a popup (normal mode)
      decode_base64_popup = "gb",

      -- Decode Base64 in a popup (visual mode)
      vdecode_base64_popup = "gb",

      -- Encode Base64 in-place (normal mode)
      encode_base64_inplace = "gB",

      -- Encode Base64 in-place (visual mode)
      vencode_base64_inplace = "gB",

      -- Decode Base64URL in-place (normal mode)
      decode_base64url_inplace = "gys",

      -- Decode Base64URL in-place (visual mode)
      vdecode_base64url_inplace = "gys",

      -- Decode Base64URL in a popup (normal mode)
      decode_base64url_popup = "gs",

      -- Decode Base64URL in a popup (visual mode)
      vdecode_base64url_popup = "gs",

      -- Encode Base64URL in-place (normal mode)
      encode_base64url_inplace = "gS",

      -- Encode Base64URL in-place (visual mode)
      vencode_base64url_inplace = "gS",

      -- Decode URL in-place (normal mode)
      decode_url_inplace = "gyl",

      -- Decode URL in-place (visual mode)
      vdecode_url_inplace = "gyl",

      -- Decode URL in a popup (normal mode)
      decode_url_popup = "gl",

      -- Decode URL in a popup (visual mode)
      vdecode_url_popup = "gl",

      -- Encode URL in-place (normal mode)
      encode_url_inplace = "gL",

      -- Encode URL in-place (visual mode)
      vencode_url_inplace = "gL",
    },
  },
}
