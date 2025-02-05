#!/usr/bin/env zsh

declare ADDITIONAL_DEPS=(
    "@chakra-ui/react"
    "@chakra-ui/theme"
    "@chakra-ui/theme-tools"
    "react-icons"
    "axios"
    "@types/axios"
    "@types/node"
)

CSS_RESET=$(cat <<EOF
/* http://meyerweb.com/eric/tools/css/reset/
   v2.0 | 20110126
   License: none (public domain)
*/

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed,
figure, figcaption, footer, header, hgroup,
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
	margin: 0;
	padding: 0;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
	display: block;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}
EOF
)

MAIN_FILE_CONTENT=$(cat <<EOF
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './assets/css/reset.css'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
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
  rm src/*.css src/*.tsx

  log "Creating assets directories"
  mkdir "src/assets/css" "src/assets/images"
  rm "src/assets/react.svg"

  log "Creating components folder."
  mkdir "src/components"

  check_error $? "folder structure refinement"

}

function create_file_templates () {
  log "Creating custom file templates."
  printf '%s' "${MAIN_FILE_CONTENT}" > src/main.tsx
  printf '%s' "${APP_FILE_CONTENT}" > src/App.tsx
  printf '%s' "${CSS_RESET}" > src/assets/css/reset.css

  # Bootstrap - assure file is in ~/.static folder
  #  cp ~/.static/bootstrap.min.css src/assets/css/

  check_error $? "custom template creation"
}


validate_user_input $1
initialize $1
install_additional_dependencies $ADDITIONAL_DEPS
refine_folder_structure
create_file_templates

npm run dev


