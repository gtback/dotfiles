#!/bin/bash

fix-time() {
    sudo sntp -sS time.apple.com
}
