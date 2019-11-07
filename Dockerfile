FROM node:12.2.0 as build

ENV OC_VERSION=v3.11.0 \
    OC_TAG_SHA=0cbc58b

RUN curl "https://get.helm.sh/helm-v3.0.0-rc.2-linux-amd64.tar.gz" -o "helm.tar.gz" \
    && tar xzvf helm.tar.gz \
    && curl -sLo /tmp/oc.tar.gz https://github.com/openshift/origin/releases/download/${OC_VERSION}/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit.tar.gz \
    && tar xzvf /tmp/oc.tar.gz -C /tmp/ \
    && mv /tmp/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit/oc /tmp/ \
    && rm -rf /tmp/oc.tar.gz /tmp/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit \
    && ls -all .
        
FROM node:12.2.0

COPY --from=build /tmp/oc /usr/local/bin/
COPY --from=build linux-amd64 /usr/local/bin
RUN  wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce-cli_19.03.4~3-0~debian-stretch_amd64.deb \
     && dpkg -i docker-ce-cli_19.03.4~3-0~debian-stretch_amd64.deb
