# 🦍 CIS vSphere


![Preview](./docs/images/preview.gif)


> A tool to assess the compliance of a VMware vSphere environment against the CIS Benchmark for VMware vSphere.

## Requirements
* VMware PowerCLI 12.0.0 or higher
* VMware vSphere 7.0
* Read access to the vCenter or ESXi host

## Usage

1. Clone the repo and navigate to the folder: 
```bash
git clone https://github.com/karimhabush/cis-vsphere.git
cd cis-vsphere
```
2. Install PowerCLI : 
```powershell
Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force
```
3. Run the script :
```powershell
.\src\cis-vsphere.ps1
```

### Notes 

* To verify the patches, you will need to update the `patches.json` file with the latest patches for your environment.

## Roadmap

* Add support for vSphere 6.5, 6.7, and 8.0

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
