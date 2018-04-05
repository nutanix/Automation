# @Author: Christophe Jauffret <tuxtof>
# @Date:   2016-07-15T15:03:54+02:00
# @Last modified by:   tuxtof
# @Last modified time: 2016-12-27T17:10:47+01:00

class DockerMachineDriverNutanix < Formula
  desc "Quickly deploy Docker hosts on Nutanix Cluster"
  homepage "http://www.nutanix.com/products/features/acropolis-container-services/"
  url "http://download.nutanix.com/utils/docker-machine-driver-nutanix.osx"
  version "1.0.8"
  sha256 "3fb565b18008e3a9a47ee264f0149f7f50524ebe946e35c4b20a52b8e44ec23c"

  def install
    bin.install "docker-machine-driver-nutanix.osx" => "docker-machine-driver-nutanix"
  end
end
