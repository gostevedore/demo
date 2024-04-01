ARG image_from_fully_qualified_name

FROM ${image_from_fully_qualified_name}

ARG app_version=unknown

COPY . .

RUN echo "Running Obelix version ${app_version}!" > obelix.txt

CMD ["/app/run.sh","obelix.txt"]
