return {
  schema = "registry+v1",
  name = "pylance",
  description = [[Fast, feature-rich language support for Python]],
  homepage = "https://github.com/microsoft/pylance",
  licenses = { "proprietary" },
  languages = { "Python" },
  categories = { "LSP" },
  source = {
    id = "pkg:lua/pylance",
    ---@param ctx InstallContext
    install = function(ctx)
      ctx.spawn.bash {
        "-c",
        ("curl -o pylance.zip https://ms-python.gallery.vsassets.io/_apis/public/gallery/publisher/ms-python/extension/vscode-pylance/%s/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"):format(
          ctx.opts.version
        ),
      }
      ctx.spawn.unzip { "pylance.zip" }
      ctx.spawn.rm { "pylance.zip" }
      ctx.spawn.bash {
        "-c",
        [[awk 'BEGIN{RS=ORS=";"} /if\(!process/ && !found {sub(/return!0x1/, "return!0x0"); found=1} 1' extension/dist/server.bundle.js | awk 'BEGIN{RS=ORS=";"} /throw new/ && !found {sub(/throw new/, ""); found=1} 1' > extension/dist/server_crack.js]],
      }
      ctx:link_bin(
        "pylance",
        ctx:write_node_exec_wrapper(
          "pylance",
          require("mason-core.path").concat { "extension", "dist", "server_crack.js" }
        )
      )
    end,
  },
}
