---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      ruff = {
        init_options = {
          settings = {
            args = {
              "--select=B,E,F,I,ANN,ASYNC,S,COM,C,ISC,PIE,PT,Q,TID,ARG,PLE,PLR,PLW,RUF",
              "--ignore=ANN101,RUF100,PLR0913,ANN102,ANN401,PLR2004,S101,COM812,COM819",
              "--line-length=120",
              "--fixable=A,B,C,D,E,F,G,I,N,Q,S,T,W,ANN,ARG,BLE,COM,DJ,DTZ,EM,ERA,EXE,FBT,ICN,INP,ISC,NPY,PD,PGH,PIE,PL,PT,PTH,PYI,RET,RSE,RUF,SIM,SLF,TCH,TID,TRY,UP,YTT",
            },
          },
        },
      },
    },
  },
}
