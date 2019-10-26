import { Config } from '@stencil/core';
import { sass } from '@stencil/sass'

export const config: Config = {
  plugins: [sass()],
  namespace: 'assets',
  globalScript: 'src/index.ts',
  globalStyle: 'src/index.scss',
  outputTargets: [
    {
      type: 'dist',
      esmLoaderPath: '../loader',
      dir: '../priv/static/dist'
    },
    {
      type: 'docs-readme'
    },
    {
      type: 'www',
      dir: '../priv/static/stencil',
      serviceWorker: null // disable service workers
    }
  ]
};
