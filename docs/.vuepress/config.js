const head = require('./config/head.js');
const themeConfig = require('./config/theme.js');
const plugins = require('./config/plugins.js');

module.exports = {
  theme: 'vdoing',
  title: "ytp'room",
  description: '我的的个人空间,简洁至上,专注知识的积累与传播。',
  markdown: {
    lineNumbers: true,
  },
  head,
  themeConfig,
  plugins,
};
