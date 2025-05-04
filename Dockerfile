# Build the application
FROM golang:latest AS builder

WORKDIR /app

COPY go.mod go.sum .
COPY *.go .
COPY *.tpl .

RUN go mod download

RUN CGO_ENABLED=0 go build -o preorder-server

# Deploy the application binary into a lean image
FROM alpine:3.20 AS production

WORKDIR /app

RUN apk add bash

COPY --from=builder /app/preorder-server .

EXPOSE 8081

CMD ["/app/preorder-server"]
