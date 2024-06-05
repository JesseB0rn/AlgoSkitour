<script setup lang="ts">
import "maplibre-gl/dist/maplibre-gl.css";
import { Map, NavigationControl, TerrainControl } from "maplibre-gl";
import { onMounted } from "vue";

const partialLayerPropsForPisteOutline = (color: string, type: number[]) => {
  return {
    paint: {
      "line-opacity": {
        base: 1,
        stops: [
          [11, 0],
          [11.1, 0.6],
        ],
      },
      "line-color": color,
      "line-gap-width": {
        base: 1.7,
        stops: [
          [11, 1.2],
          [18, 6],
        ],
      },
      "line-width": 1.5,
    },
    filter: ["in", ["get", "piste_type"], ["literal", type]],
  };
};
const partialLayerPropsForPiste = (color: string, type: number[]) => {
  return {
    paint: {
      // "line-color": "#ff0000",
      // "line-width": 4,
      "line-color": color,
      "line-opacity": {
        base: 1,
        stops: [
          [11, 0],
          [11.1, 1],
        ],
      },
      "line-width": {
        base: 1.7,
        stops: [
          [11, 1],
          [18, 6],
        ],
      },
    },
    filter: ["in", ["get", "piste_type"], ["literal", type]],
  };
};

onMounted(() => {
  const map = new Map({
    container: "map",
    zoom: 12,
    // center: [8.40523, 46.70214],
    center: [7.57353, 46.40102],
    pitch: 55,
    bearing: -40,
    hash: true,
    style: "https://vectortiles.geo.admin.ch/styles/ch.swisstopo.basemap.vt/style.json",
    maxZoom: 18,
    maxPitch: 80,
  });

  map.addControl(
    new NavigationControl({
      visualizePitch: true,
    })
  );

  map.addControl(
    new TerrainControl({
      source: "terrainSource",
      exaggeration: 1,
    })
  );

  map.on("load", async () => {
    map.addSource("terrainSource", {
      type: "raster-dem",
      url: "https://shop.robofactory.ch/services/tiles_swissalps.json",
      attribution: "SwissAlti3D © Swisstopo",
      tileSize: 256,
    });
    map.addSource("fatmaplocs", {
      minzoom: 9,
      type: "vector",
      tiles: ["https://tiles.platform.fatmap.com/fatmap/{z}/{x}/{y}.pbf?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4M29iazA2Z2gycXA4N2pmbDZmangifQ.-g_vE53SD2WrJ6tFX7QHmA"],
      attribution: "Outdoorlocations © Fatmap",
    });

    map.setTerrain({
      source: "terrainSource",
    });
    map.addImage(
      "POI_Peak",
      (
        await map.loadImage(
          "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAACv0lEQVR4nO2YX0hTYRjGVwbdBlEbazvb9DQTu5BKq6GFiXgRSV2EQUHBMgjBCi/Mi6IgMiiyiAohCvuDVLgiuoooMCZ2YXQT3Ui3URRmVlJBX8938D18pdPpzvYivD948MadPb/3fPu+s/l8giAIgiAIgiAIgiAIgiAIBSAUCq0Ae/E3GQwGLe4+BSUcDjdAfBRRE/mGYWzh7lUQILtSCxvylLFIJBLj7pdviiCaJum1m9Y7MYbwHP+zkLtk3sAy7yDZSCyqLr+6qy4N9SorGjGH0MrdMy9YllUOuXESPdjVrh6Ov3Syv/OIOYDvGFScu6/XLMLGN0SS1VtrVd/YgDuAvq9ptaG+xhxCP16zgLu0Z0C+jeRidrHqfpNy5Sn646A/FsYQkty9PUGf8XqHJ7GWi0cnyVOSp1rNAXz2+/3LufvnDO7+I5KqqkuolLH0/8/9kReqIrHOHQJe28PdPycgscOVsSx1YfB2RnlK55NucxX8wQpKcHvMCdu2F0NgmGR2dzTPKE9pPNBkDmHANx83RBRvJ4l4+Sp15/3TrAdwffixipXE3CHgWNzJ7TMr9OaF4l9IoO3ayazlKftOtJir4J1eUdxeWYM7doXKV9Zu/OfMzza9H56p0tVl5io4zO2VFXjiK0bhX1Rcb2qzlaccunrMXAWfotHoEm6/GUHRm1R68/b6Ocvr6CNzTXWlOYSz3H7TgiOrFCV/U+Fz/TdyGoDO8VSXOYCfeDYo4fbMCMrdo7INexpzltd58GNQ1WyrM4dwi9szE0X0yItBOF9zvRiAzvl0j3PNiQGM6vfilp0ENqgA3SW7LO583dXP/V5EX0tfk66v34vbd0pQ7vUUP3V5nbfcnhnBWV2Bgh/zKD+CVHF7TguGsBSf1ybkNMqe8SL6WsiuQCCwjNtPEARBEARBEARBEARBEIT5zV9URaR/ScprHwAAAABJRU5ErkJggg=="
        )
      ).data
    );
    map.addImage(
      "POI_Hut",
      (
        await map.loadImage(
          "data:image/png;base64,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"
        )
      ).data
    );
    map.addImage(
      "lift",
      (
        await map.loadImage(
          "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEU0lEQVR4nO1aW0tUURQe/4Yz55iO2RR2MUEfEhztObqIQgXSQ0U9pGQXqbTU7nalsh6KxC6EQWZUZIJJmfcy6MJ4ox66aZmQI0Vqrtbac840VjNnZM4+Z8z9wYJ5OK61vu+svfZ2n2WxCAgICAgICAgICISKCFmWE61Wa4nNZqtHc6ENo0GINqz4Ip/FkZGRC80m+icikHQWJtelA9lgrQtjZlJsU5lLkmTHZFq8iclxINnTQHasBmnOOpDjc0GeuyU0Qx/MF/m0O1kMHyFasOpiTCGPgVMwgX4P8ZkgxS3DZDeHTljT8kCaleUrxBeshnRDyWPANAw8whKITtbnTU/SpPgcjJ2kivADzWkIeaXsByiwFJvO3ojR5CdUgz1dFeFzVFRUNG/+ERio1fvmTSX/WwSfSmiy8GyMSrdna96Msg+4HDAnRYQMXvwj1K1OmrXcdNJ/iYBNWBHAxYU9HXLUrU6O51P6cxcVgHPJIViRfRrW5lyE7Xuuw5FT9+DC5UdQdfsJ1D92QfHh6n//Pe5AahXgYSlBdwGw/Peyt0/7fBBkZszfCgmpe2DxslLIXFMGG/IqoGDfDThWVgPlVxvg1r1n0NTaA67uD9D/6SuMjo6BFkZGxuByZZPfmDY6J3iqoEh3AZSjKEiOVX4ToLfV3dsHA4NuGB8f1ySkog8FaO94AzV1L+BSZSOcPFcLhQeqmGgkXvrSUpiXUqi9DBwrVQHqeAjQTc7lOev9JlBx7TEj09nzEVqfvoba+pdwvboNzl96CEfP1EDB/irYlH8Fsjeeh3W55fDt+wi8ez8I0fO36dMH8MSoCNDJQwA3E0DH7v/81VtmuvURzE0RwM1DAOZcz6anuwDUB5Q8hQDhLkBiWhFrlmT0e1oIUH23Q3NHuHnn6f8rwCvXe00B6BkhwFQV4PjZ+97G9i+jfV8L9EwgH3SSDFsBuno/ahIMFRQj7AVwJO3QLNWYhO0w5P7OjH5rPT87eefUESDY9apug8E+LwQQAggBpoYAZRfq4OCJOwHtBG6Zo2M/mdFvrefJ55QRgCeEACYKMMSuxOJzwlgA74XIVx4CdGldiTW393IXoLmt1298nysx/a/G0ekDrUvRktJb3AXYtfeGfwE4X4oWa12LxybmQ0NzNzfy9Q0udt3ud/3bU1UBdusuAE1mBPNhhBKk+38q1UD/1U3GyBe9+UDkfT+MWK3WBboLYPF8GutkVRA3DT+NEWgsxTsQEWA3MN6w+0uxqgAruAlg8VRBc7h9HpdiklXyjRbec0M0k0PDCJ6GGA4DEmneAYkZCK7kVWAwp807IpNk0nLIBWniiEyqIeRVTBySsoM0c4lxQ1JxGb5rfsDwISkVNJODCTSp52+2Ddmd7LCk95gcO+TQPv97EoSteSPmgrRAjTHD5pnmNGpQ0qV0e3MHJf8ETWZgYkV0FFWSdOtA1q34Ip9FXKY/BAQEBAQEBAQEpiF+Af0mimbQzrSeAAAAAElFTkSuQmCC"
        )
      ).data
    );
    map.addImage(
      "POI_Transit",
      (
        await map.loadImage(
          "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAFEElEQVR4nO1aXUwcVRTmUR/UqLyw7C4/HVCwxNUWykrjqjFtH6QYqlEoBBOjMUbTqgmtphqrD0bbmmrR0oLd0mJLfxTbNBpr0VpAw7JV6GKRWpoghdofoPjQ0mV3r+fcnamz0JnpsHNnunq/5GQD2T3nO9+ce2fm3JOUxMHBwcHBwcHBET9SUlLSHA7Hq6mpqfvsdrsfbBhsNE5DH370CfYKxrA6z2kAYm4geQSMmGRHIGah1XknZWZm3gZkPgeLIDGHI41kzV5IXA+tJPmL1hF3yVZSVLozLkMf6At9ZuctpDFEETBmI3KwJHksRSDQQ8k4nOSegmfI/Cebiaf8EFOb/8SXJLegSi5EwPRlkQ6AwGeQQEbWHOJ+vIF54lPNXdJAMoT7JRGGTRMBgt0M9gsGFnI9plx1xWqA2MhBFMEP1+Um5gLALl+LAdNnuYDAV5YlLxchQ3BREWBj/IRp8jab7W4IFMI1X1hcb3nykhUurpf2hEkQIZuZAHD1d6HSufkVmqReeNNHDvwwRI6fHCd9p/6esfkDI2T91t/Jo1Xfq8bLmVsuVcFOJsmD4zujVz+NFC3ZrUrGu7efRCLEUPT2j5PHnjusGLOodBexi1UAdgcLASpR4ey8RarJv1f7m7GZy3Cw9YxqbHxOEDfEcsMFEB946AOJEoGHK1rI+dGJacSbDgyQsuXtuqz54OA0P+FwhJS+2KoY3+WplgRoZCFAJzovLK5TJPD8Kt81r9ylyyEydPaSLrs8Ebqmr+r3f1WMP694kyRABwsBTqPzoiV7FAms+rA7vhq/Dqxc06W8D8DeJAowyEKAIDr3lH2rSODtjwOUZBh2wJrtJ0jFaz/pLv2phj4+bTxxdVNdoSIAchMFCLIQgDpX24QkAdr85wy/1/u6L2gLACbxtFSAPd/8abgA+1tOJ44Au78e4AJwAbgAXID/rwCH2v8yXIC2o+cTR4DgZJi8sbaLPFLZEnfi6AP9hkKRxBGAJbgAXAAuwI0vQDAYpkRxA3u3poe+HeoFNj/eWn+M+sDX7MlE2gS/a49tXR3tGdEtQDvc9uQ+WjvPJY4AP3acjfl/oG9MtwC+YyMxPjq6rH8dvv6GCJTvus96yVPL2sjmppO6k6c+YNls2NZHfeDnjdAQGYy2xJRb4ngWwBpV1T8rxqet8agAAywE8Gk1RdG8X5wioxevxJAeHb+iuyk6Nh7r48LYBNkE1aQWm3VTNNoW96xQJYGG/UA53qkJaP5mqn1QdzzGx9r6Xs3fyNri21kIsBSdZ2kcjKDhmpVj9YYZCLA5VoA1ddoCZOctINFBDcfThgsQczQGa02NCPbu5Xj29Q7dAry02h/j42X4W+37D5Q2XT0aczqdtxsuAOLfw9Glmgls2dsPt7+L5KOGPt3JS7Zxxx/URy18an03Z06ZVP47mCSPsNlsd2EV4FE0HknPNDGjDTdmU47HEVAFG+lojOCydDpEMuSQLtwrXf0apskjxBEZPx2RyfHQoSXLkofYs3IelJLvNGVEBiFOiA3TURnhPuIu8Zpf9ou3QGyXlPwQLE+nKclLwIAQOGAX5wNz8yuhHNlXA8bAWLIxuW7g4jA1eQmCINyKDx122aAk3ovxgWQuHZT0GjAo6aW+0GfW7AUQwykflNyWnJx8iyXJywFE5oEdloRgbBExVoHVeU8DLgu4DS0Hcs326ECFUcPSnaLPZaavdQ4ODg4ODg6O/yr+AaAVQPOzotxJAAAAAElFTkSuQmCC"
        )
      ).data
    );
    map.addLayer({
      id: "piste-blue",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPiste("#254cb6", [1, 2, 7, 8]),
    } as any);
    map.addLayer({
      id: "piste-blue-outline",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPisteOutline("hsl(0, 100%, 100%)", [1, 2, 7, 8]),
    } as any);
    map.addLayer({
      id: "piste-red",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPiste("hsl(3, 73%, 44%)", [3, 9]),
    } as any);
    map.addLayer({
      id: "piste-red-outline",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPisteOutline("hsl(0, 100%, 100%)", [3, 9]),
    } as any);
    map.addLayer({
      id: "piste-black",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPiste("#1c1c1c", [4, 10]),
    } as any);
    map.addLayer({
      id: "piste-black-outline",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPisteOutline("hsl(0, 100%, 100%)", [4, 10]),
    } as any);
    map.addLayer({
      id: "piste-itin",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPiste("hsl(42, 100%, 47%)", [5, 16]),
    } as any);
    map.addLayer({
      id: "piste-itin-outline",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_pistes",
      ...partialLayerPropsForPisteOutline("hsl(0, 100%, 100%)", [5, 16]),
    } as any);
    map.addLayer({
      id: "lifts",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_lifts",
      layout: { "line-cap": "round" },
      paint: {
        "line-color": "#eaf1f5",
        "line-width": {
          base: 1.5,
          stops: [
            [11, 1],
            [18, 2],
          ],
        },
        "line-opacity": {
          base: 1,
          stops: [
            [11, 0],
            [11.1, 1],
          ],
        },
      },
    } as any);
    map.addLayer({
      id: "lifts-outline",
      type: "line",
      source: "fatmaplocs",
      "source-layer": "fatmap_lifts",
      layout: { "line-cap": "round" },
      paint: {
        "line-opacity": {
          base: 1,
          stops: [
            [11, 0],
            [11.1, 0.6],
          ],
        },
        "line-gap-width": {
          base: 1.5,
          stops: [
            [11, 1],
            [18, 2],
          ],
        },
        "line-width": 1.5,
      },
    } as any);
    map.addLayer({
      id: "lifts-icon",
      type: "symbol",
      source: "fatmaplocs",
      "source-layer": "fatmap_lifts_point",
      layout: {
        "text-size": {
          base: 1,
          stops: [
            [15, 10],
            [16, 11],
          ],
        },
        "icon-image": "lift",
        "icon-rotation-alignment": "viewport",
        "icon-keep-upright": !0,
        "symbol-spacing": 500,
        "text-font": ["Frutiger Neue Bold"],
        "text-justify": "left",
        "text-offset": [1.5, -0.05],
        "icon-size": {
          base: 0.35,
          stops: [
            [13, 0.35],
            [16, 0.45],
          ],
        },
        "text-anchor": "left",
        "text-field": ["get", "name"],
        "text-letter-spacing": 0.04,
        "icon-padding": 0,
        "text-max-width": 15,
      },
      paint: {
        "text-color": "hsl(0, 0%, 100%)",
        "text-opacity": {
          base: 1,
          stops: [
            [13.5, 0],
            [13.6, 1],
          ],
        },
        "text-halo-color": "#1c1c1c",
        "text-halo-width": 1,
        "icon-translate": [0, 0],
        "icon-opacity": {
          base: 1,
          stops: [
            [12.9, 0],
            [13, 1],
          ],
        },
        "text-translate": [0, 0],
      },
    } as any);

    map.addSource("bulletin", {
      type: "geojson",
      data: await (await fetch("https://aws.slf.ch/api/bulletin/caaml/de/geojson")).json(),
    });
    map.addLayer({
      minzoom: 1,
      maxzoom: 10,
      id: "bulletin",
      source: "bulletin",
      type: "fill",
      paint: {
        "fill-color": ["get", "fill"],
        "fill-opacity": {
          base: 0.35,
          stops: [
            [9, 0.35],
            [9.9, 0.0],
          ],
        },
      },
    } as any);
  });
});
</script>

<template>
  <div id="map"></div>
</template>

<style scoped>
#map {
  width: 100%;
  height: calc(100vh - 5rem);
}
</style>
