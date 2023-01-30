 terraform {
   cloud {
     organization = "samuellee-dev"
     hostname = "app.terraform.io" # Optional; defaults to app.terraform.io

     workspaces {
       name = "Application_A_Security"
     }
   }
 }

 provider "aws" {
   region = "ap-southeast-2"
 }
