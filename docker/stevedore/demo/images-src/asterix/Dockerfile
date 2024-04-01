ARG image_from_fully_qualified_name

FROM ${image_from_fully_qualified_name}

ARG app_version=unknown

RUN echo "Running Asterix version ${app_version}!" > /asterix.txt

CMD ["cat","/asterix.txt"]
