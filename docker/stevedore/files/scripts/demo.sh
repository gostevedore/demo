#!/bin/bash

########################
# include the magic
########################
. /demo-magic.sh

DEMO_PROMPT="${BLUE}\w${COLOR_RESET} $(echo -e "\u276F") "
TYPE_SPEED=40

function press_enter() {
    pei "echo 'Press Enter to continue...'"
    wait
}

function press_enter_clear() {
    press_enter
    clear
}


mkdir -p /stevedore
cd /stevedore || exit

clear
pei "echo 'Press Enter to start the demo...'"
wait
clear

# pei ""
pei "stevedore version"

press_enter_clear

pei "stevedore initialize --generate-credentials-encryption-key --images-path images --log-path-file /dev/null"

press_enter_clear

pei "echo 'The requested password is: admin'"
pei "stevedore create credentials registry.stevedore.test --username admin"
pei "stevedore get credentials --show-secrets"

press_enter_clear

pei "mkdir -p images"
pei "mkdir -p images-src/base"

pei "echo 'Press Enter to continue...'"

p "cat << EOF > images-src/base/Dockerfile

ARG image_from_name
ARG image_from_tag

FROM \${image_from_name}:\${image_from_tag}

# Create a new user
RUN echo \"tutatis:x:10001:10001:,,,:/app:/bin/sh\" >> /etc/passwd && \
    echo \"tutatis:x:10001:\" >> /etc/group && \
    mkdir -p /app && \
    chown 10001:10001 /app

# Set the user as the default user
USER tutatis
WORKDIR /app
EOF

# Press Enter to continue...
"

cat << EOF > images-src/base/Dockerfile
ARG image_from_name
ARG image_from_tag

FROM \${image_from_name}:\${image_from_tag}

# Create a new user
RUN echo "tutatis:x:10001:10001:,,,:/app:/bin/sh" >> /etc/passwd && \
    echo "tutatis:x:10001:" >> /etc/group && \
    mkdir -p /app && \
    chown 10001:10001 /app

# Set the user as the default user
USER tutatis
WORKDIR /app
EOF

clear
pei "echo 'Press Enter to continue...'"

p "cat << EOF > images/base.yaml

images:
  # Definitions for foundational images from Dockerhub
  busybox:
    \"1.36\":
      persistent_labels:
        created_at: \"{{ .DateRFC3339Nano }}\"

  # Definitions for base images
  base:
    busybox-1.36:
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/base
      parents:
        busybox:
          - \"1.36\"
EOF

# Press Enter to continue...
"

cat << EOF > images/base.yaml
images:
  # It define the foundational images from Dockerhub
  busybox:
    "1.36":
      persistent_labels:
        created_at: "{{ .DateRFC3339Nano }}"

  base:
    busybox-1.36:
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/base
      parents:
        busybox:
          - "1.36"
EOF

press_enter_clear
pei "stevedore get images --tree"

press_enter_clear
pei "stevedore build base --push-after-build"

press_enter_clear

pei "mkdir -p images-src/asterix"

clear
pei "echo 'Press Enter to continue...'"
p "cat << EOF > images-src/asterix/Dockerfile

ARG image_from_fully_qualified_name

FROM \${image_from_fully_qualified_name}

ARG app_version=unknown

RUN echo \"Running Asterix version \${app_version}!\" > asterix.txt

CMD [\"cat\", \"asterix.txt\"]
EOF

# Press Enter to continue...
"

cat << EOF > images-src/asterix/Dockerfile
ARG image_from_fully_qualified_name

FROM \${image_from_fully_qualified_name}

ARG app_version=unknown

RUN echo "Running Asterix version \${app_version}!" > asterix.txt

CMD ["cat", "asterix.txt"]
EOF

clear
pei "echo 'Press Enter to continue...'"
p "cat << EOF > images/apps.yaml

images:
  asterix:
    \"1.2.3\":
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/asterix
      parents:
        base:
          - \"busybox-1.36\"
      vars:
        app_version: \"{{ .Version }}\"
    \"2.3.1\":
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/asterix
      parents:
        base:
          - \"busybox-1.36\"
      vars:
        app_version: \"{{ .Version }}\"
    \"*\":
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/asterix
      parents:
        base:
          - \"busybox-1.36\"
      vars:
        app_version: \"{{ .Version }}\"
EOF

# Press Enter to continue...
"

cat << EOF > images/apps.yaml

images:
  asterix:
    "1.2.3":
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/asterix
      parents:
        base:
          - busybox-1.36
      vars:
        app_version: "{{ .Version }}"
    2.3.1:
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - path: images-src/asterix
      parents:
        base:
          - busybox-1.36
      vars:
        app_version: "{{ .Version }}"
    "*":
      registry: registry.stevedore.test
      version: "{{ .Version }}"
      builder:
        driver: docker
        options:
          context:
            - path: images-src/asterix
      parents:
        base:
          - busybox-1.36
      vars:
        app_version: "{{ .Version }}"
EOF

press_enter_clear
pei "stevedore get images --tree"


press_enter_clear
pei "stevedore build asterix"

press_enter_clear

pei "docker run --rm registry.stevedore.test/asterix:1.2.3"
pei "docker run --rm registry.stevedore.test/asterix:2.3.1"

press_enter_clear

pei "stevedore promote registry.stevedore.test/asterix:1.2.3 --enable-semver-tags --semver-tags-template \"{{ .Major }}\" --semver-tags-template \"{{ .Major }}.{{ .Minor }}\""

press_enter_clear

# pei "stevedore build asterix --image-version 3.0.0-rc1"

# wait
# clear

# pei "docker run --rm registry.stevedore.test/asterix:3.0.0-rc1"

# wait
# clear


pei "echo 'The requested password is: password'"
pei "stevedore create credentials gitserver.stevedore.test --private-key-file /root/.ssh/id_rsa --ask-private-key-password"
pei "stevedore get credentials --show-secrets"

clear
pei "echo 'Press Enter to continue...'"
p "cat << EOF >> images/apps.yaml

  obelix:
    \"3.4.5\":
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - git:
                repository: git@gitserver:/git/repos/dockerfile.git
                auth:
                    credentials_id: gitserver.stevedore.test
            - git:
                repository: git@gitserver:/git/repos/obelix.git
                auth:
                    credentials_id: gitserver.stevedore.test
      parents:
        base:
          - \"busybox-1.36\"
      vars:
        app_version: \"{{ .Version }}\"
EOF

# Press Enter to continue...
"

cat << EOF >> images/apps.yaml

  obelix:
    "3.4.5":
      registry: registry.stevedore.test
      builder:
        driver: docker
        options:
          context:
            - git:
                repository: git@gitserver:/git/repos/dockerfile.git
                auth:
                    credentials_id: gitserver.stevedore.test
            - git:
                repository: git@gitserver:/git/repos/obelix.git
                auth:
                    credentials_id: gitserver.stevedore.test
      parents:
        base:
          - busybox-1.36
      vars:
        app_version: "{{ .Version }}"
EOF

press_enter_clear

pei "stevedore get images --filter name=obelix"

press_enter_clear

pei "stevedore build obelix"

press_enter_clear

pei "docker run --rm -it registry.stevedore.test/obelix:3.4.5"

press_enter_clear

# pei "docker system prune --all --force"
# pei "docker images"

# wait
# clear

# pe "stevedore build base --build-on-cascade"

# wait
# clear

# pei "docker images"

# wait
# clear

pei "docker inspect --format '{{ index .Config.Labels \"created_at\" }}' registry.stevedore.test/obelix:3.4.5"

pei "echo 'Press Enter to finish the demo...'"
wait
clear
