local pypi = require("mason-core.installer.managers.pypi")
return {
  schema = "registry+v1",
  name = "systemd_ls",
  description = [[Fast, feature-rich language support for Python]],
  homepage = "https://github.com/psacawa/systemd-language-server",
  licenses = { "GPL-3.0" },
  languages = { "systemd" },
  categories = { "LSP" },
  source = {
    id = "pkg:lua/systemd_ls",
    ---@param ctx InstallContext
    install = function(ctx)
      -- NOTE: using my fork, opened PR upstream https://github.com/psacawa/systemd-language-server/pull/4
      pypi.install({ "git+https://github.com/RayJameson/systemd-language-server.git" }):with_receipt() -- very easy way to install this...
      ctx:link_bin("systemd_ls", "venv/bin/systemd-language-server")

      -- pip3.install { "systemd-language-server" }:with_receipt() -- very easy way to install this...

      -- ctx.receipt:with_primary_source(ctx.receipt.pip3("systemd-language-server")):with_name("systemd_ls")
      -- I will leave this here as a reminder of my attempts before I found mason-core.managers.pip3 ...
      --[[
      ctx.spawn.python3 {
        "-m",
        "venv",
        "--systemd-site-packages",
        "venv",
      }
      ctx.spawn.bash {
        "-c",
        "source venv/bin/activate && pip3 install --disable-pip-version-check systemd-language-server",
      }
      ctx:link_bin("systemd_ls", ".venv/bin/systemd-language-server")
    --]]
    end,
  },
}
