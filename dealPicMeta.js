const program = require('commander');
const fs = require('fs');
const { exit } = require('process');

// console.log(process.argv);

program
	.version('0.0.1')
	.usage('<quality> <metaPaths> [options]')
	.option('-quality, --quality [quality]', 'Quality')
	.option('-metaPaths, --metaPaths [metaPaths]', 'MetaPaths')
	.parse(process.argv);

if (program.args.length < 2) {
	program.help();
}

let quality = parseInt(program.args[0]);
let metaPaths = program.args[1];

// console.log("metaPaths:", metaPaths);

if (isNaN(quality)) {
    console.error("error: quality is NaN.");
    exit(1);
}

let metaPathArr = metaPaths.split(",");
// console.log("metaPathArr:", metaPathArr);
let metaPath;
for (let i = 0; i < metaPathArr.length; i++) {
    metaPath = metaPathArr[i];
    // console.log("metaPath:", metaPath);
    let metaCon = fs.readFileSync(metaPath);
    let metaJson = JSON.parse(metaCon.toString());
    let platformSettings = metaJson.platformSettings;
    if (platformSettings) {
        let defaultCfg = platformSettings.default;
        if (!defaultCfg) {
            defaultCfg = platformSettings.default = {};
        }
        let formats = defaultCfg.formats;
        if (!formats) {
            formats = defaultCfg.formats = [];
        }
        let hasWebp = false;
        let format;
        for (let i = 0; i < formats.length; i++) {
            format = formats[i];
            if (format.name === "webp") {
                hasWebp = true;
                break;
            }
        }
        let isChg = false;
        if (!hasWebp) {
            formats.push({
                "name": "webp",
                "quality": quality
            });
            isChg = true;
        } else {
            if (format.quality !== quality) {
                format.quality = quality;
                isChg = true;
            }
        }
        if (isChg) {
            fs.writeFileSync(metaPath, JSON.stringify(metaJson, null, "  "));
        }
    }
}
