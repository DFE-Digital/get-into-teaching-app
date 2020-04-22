import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

import hljs from "highlightjs";
import "highlightjs/styles/github.css";
hljs.initHighlightingOnLoad();

import "../../../lib/design_system/style.scss";

const application = Application.start();
const context = require.context("../../../lib/design_system", true, /\.js$/);
application.load(definitionsFromContext(context));
