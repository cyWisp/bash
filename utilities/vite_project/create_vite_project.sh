#!/usr/bin/env zsh

declare ADDITIONAL_DEPS=(
    "@chakra-ui/react"
    "@chakra-ui/theme"
    "@chakra-ui/theme-tools"
    "@emotion/react"
    "react-icons"
    "axios"
    "@types/axios"
    "@types/node"
    "dotenv"
)

TSCONFIG_TEMPLATE=$(cat << EOF
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "paths": {
      "@/*": ["./src/*"]
    },

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "erasableSyntaxOnly": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true
  },
  "include": ["src"]
}

EOF
)

VITE_CONFIG_TEMPLATE=$(cat <<EOF
import { defineConfig } from 'vite'
import tsconfigPaths from "vite-tsconfig-paths"
import react from '@vitejs/plugin-react'
import dotenv from 'dotenv'

const configPaths = [
    './.config/.env.local',
    '../../.config/.env.global'
]

dotenv.config({path: configPaths})

// Define default values for the environment variables
const logLevel = process.env.VITE_LOG_LEVEL || 'info'
const appTitle = process.env.VITE_APP_TITLE || 'My App'
const appPort = process.env.VITE_APP_PORT
  ? parseInt(process.env.VITE_APP_PORT)
  : 3001


// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  define : {
    __APP_TITLE__: JSON.stringify(logLevel),
    __LOG_LEVEL__: JSON.stringify(appTitle),
    __PORT__: JSON.stringify(appPort)
  },
  server: {
    port: appPort
  }
})

EOF
)

CONFIG_FILE_TEMPLATE=$(cat <<EOF
VITE_LOG_LEVEL=info
VITE_APP_TITLE='New Project'
VITE_APP_PORT=3001

EOF
)

# Use this to generate a css reset file
#CSS_RESET=$(cat <<EOF
#/* http://meyerweb.com/eric/tools/css/reset/
#   v2.0 | 20110126
#   License: none (public domain)
#*/
#
#html, body, div, span, applet, object, iframe,
#h1, h2, h3, h4, h5, h6, p, blockquote, pre,
#a, abbr, acronym, address, big, cite, code,
#del, dfn, em, img, ins, kbd, q, s, samp,
#small, strike, strong, sub, sup, tt, var,
#b, u, i, center,
#dl, dt, dd, ol, ul, li,
#fieldset, form, label, legend,
#table, caption, tbody, tfoot, thead, tr, th, td,
#article, aside, canvas, details, embed,
#figure, figcaption, footer, header, hgroup,
#menu, nav, output, ruby, section, summary,
#time, mark, audio, video {
#	margin: 0;
#	padding: 0;
#	border: 0;
#	font-size: 100%;
#	font: inherit;
#	vertical-align: baseline;
#}
#/* HTML5 display-role reset for older browsers */
#article, aside, details, figcaption, figure,
#footer, header, hgroup, menu, nav, section {
#	display: block;
#}
#body {
#	line-height: 1;
#}
#ol, ul {
#	list-style: none;
#}
#blockquote, q {
#	quotes: none;
#}
#blockquote:before, blockquote:after,
#q:before, q:after {
#	content: '';
#	content: none;
#}
#table {
#	border-collapse: collapse;
#	border-spacing: 0;
#}
#EOF

#)

MAIN_FILE_CONTENT=$(cat <<EOF
import { Provider } from "@/components/ui/provider"
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
// import './assets/css/reset.css'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <Provider>
        <App />
    </Provider>
  </StrictMode>,
)

EOF
)

APP_FILE_CONTENT=$(cat <<EOF
import { useState } from 'react'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <h1>Vite + React</h1>
      <div>
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>
    </>
  )
}

export default App

EOF
)


function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2"
}

function check_error () {
  if [ $1 -ne 0 ]; then
    log "[x]" "Previous operation returned a non-zero status - exiting..."
    log "[x]" "Failed at ${2}."
    exit 1
  fi
}

function validate_user_input () {
  if [ -z "${1}" ]; then
    log "Please provide project name. Exiting."
    exit 1
  fi
}

function initialize () {
  log "Creating new vite project in current directory."
  npm create vite@latest $1 -- --template react-ts

  check_error $? "project initialization."

  cd $1
  npm i

  check_error $? "dependency installation"
}

function add_snippets () {
    npx @chakra-ui/cli snippet add

    check_error $? "add snippets"
}

function setup_vite_config_paths () {
    npm i -D vite-tsconfig-paths

    check_error $? "setup vite config paths"
}

function install_additional_dependencies () {
    log "Installing additional dependencies."

    for d in "${ADDITIONAL_DEPS[@]}"; do
        npm i "${d}" --save-dev
    done

    check_error $? "additional dependencies"
}

function refine_folder_structure () {
  log "Refining directory structure."

  log "Removing default css templates."
  rm "src/*.css src/*.tsx"

  log "Creating assets directories"
  mkdir "src/assets/css" "src/assets/images"
  rm "src/assets/react.svg"

  log "Creating components folder."
  mkdir "src/components"

  log "Creating config directory"
  mkdir ".config"

  log "Removing legacy TS config"
  rm "./tsconfig.app.json"

  check_error $? "folder structure refinement"

}

function create_file_templates () {
  log "Creating custom file templates."
  printf '%s' "${CONFIG_FILE_TEMPLATE}" > .config/.env.local
  printf '%s' "${VITE_CONFIG_TEMPLATE}" > vite.config.ts
  printf '%s' "${MAIN_FILE_CONTENT}" > src/main.tsx
  printf '%s' "${APP_FILE_CONTENT}" > src/App.tsx
#  printf '%s' "${CSS_RESET}" > src/assets/css/reset.css
  printf '%s' "${TSCONFIG_TEMPLATE}" > tsconfig.app.json


  # Bootstrap - assure file is in ~/.static folder
  #  cp ~/.static/bootstrap.min.css src/assets/css/

  check_error $? "custom template creation"
}


validate_user_input $1
initialize $1
install_additional_dependencies $ADDITIONAL_DEPS
add_snippets
setup_vite_config_paths
refine_folder_structure
create_file_templates

npm run dev


