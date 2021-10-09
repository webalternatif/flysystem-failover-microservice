#!/bin/bash

for COMMAND in $@ ; do
  FILE="/usr/local/bin/$COMMAND"

  echo '#!/bin/bash'                                                      > "$FILE"
  echo                                                                   >> "$FILE"
  echo 'cd /opt/app'                                                     >> "$FILE"
  echo 'exec bin/exec bin/console webf:flysystem-failover:'$COMMAND' $@' >> "$FILE"

  chmod +x "$FILE"
done
