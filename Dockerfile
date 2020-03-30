FROM node:12.2.0 as build

ENV OC_VERSION=v3.11.0 \
    OC_TAG_SHA=0cbc58b

RUN curl "https://get.helm.sh/helm-v3.0.0-rc.2-linux-amd64.tar.gz" -o "helm.tar.gz" \
    && tar xzvf helm.tar.gz \
    && curl "https://get.helm.sh/helm-v3.0.0-beta.4-linux-amd64.zip" -o "helm3beta4.zip" \
    && curl "https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64" -o /tmp/yq \
    && curl "https://github.com/argoproj/argo-cd/releases/download/v1.4.2/argocd-linux-amd64" -o /tmp/argocd \
    && unzip helm3beta4.zip -d /tmp/ \
    && curl -sLo /tmp/oc.tar.gz https://github.com/openshift/origin/releases/download/${OC_VERSION}/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit.tar.gz \
    && tar xzvf /tmp/oc.tar.gz -C /tmp/ \
    && mv /tmp/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit/oc /tmp/ \
    && rm -rf /tmp/oc.tar.gz /tmp/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit \
    && ls -all .
        
FROM node:12.2.0

COPY --from=build /tmp/yq /usr/local/bin/
COPY --from=build /tmp/argocd /usr/local/bin/
COPY --from=build /tmp/oc /usr/local/bin/
COPY --from=build linux-amd64 /usr/local/bin
COPY --from=build /tmp/linux-amd64/helm /usr/local/bin/helm3beta4
RUN  wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce-cli_19.03.4~3-0~debian-stretch_amd64.deb \
     && dpkg -i docker-ce-cli_19.03.4~3-0~debian-stretch_amd64.deb
