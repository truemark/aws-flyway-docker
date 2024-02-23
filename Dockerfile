FROM flyway/flyway:latest

RUN apt-get update && apt-get install -y --no-install-recommends -qq curl unzip groff && apt-get -qq clean && rm -rf /var/lib/apt/lists;
RUN curl -sSLf "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
COPY --from=truemark/jq:latest /usr/local/ /usr/local/
COPY helper.sh /usr/local/bin/helper.sh
COPY aws.sh /usr/local/bin/aws.sh
RUN chmod +x /usr/local/bin/aws.sh

ENTRYPOINT ["/bin/bash"]
