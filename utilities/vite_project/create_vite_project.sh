#!/usr/bin/env zsh

MAIN_FILE_CONTENT=`cat <<EOF
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
EOF
`

APP_FILE_CONTENT=`cat <<EOF
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
`


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
  echo $MAIN_FILE_CONTENT > src/main.tsx
  echo $APP_FILE_CONTENT > src/App.tsx

  check_error $? "custom template creation"
}


validate_user_input $1
initialize $1
refine_folder_structure
create_file_templates

npm run dev


