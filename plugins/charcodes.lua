-- Crée une popup qui affiche les codes de charactères de la table ASCII et 
-- codes des charactères de 0x2500 à 0x253F (charactères servant à dessiner 
-- des tableaux)
--
-- Utilisation:
--      local charcodes_popup = require("plugins.charcodes")
--      awful.key({ modkey, }, key, function () charcodes_popup.toggle() end),

local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local charcodes = {}
charcodes.table = [[
┏━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━┯━━━━━━━━━━━┳━━━━━━━━━━━┯━━━━━┳━━━━━━━━━━━━━┯━━━━━━━━━━┓ ┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
┃  0  0x00 │  [NULL]                  ┃  32  0x20 │  [SPACE]  ┃  64  0x40 │  @  ┃   96   0x60 │ `        ┃ ┃ 2500 ─  ┃ 2510 ┐  ┃ 2520 ┠  ┃ 2530 ┰  ┃
┃  1  0x01 │  [START OF HEADING]      ┃  33  0x21 │  !        ┃  65  0x41 │  A  ┃   97   0x61 │ a        ┃ ┃         ┃         ┃         ┃         ┃
┃  2  0x02 │  [START OF TEXT]         ┃  34  0x22 │  "        ┃  66  0x42 │  B  ┃   98   0x62 │ b        ┃ ┃ 2501 ━  ┃ 2511 ┑  ┃ 2521 ┡  ┃ 2531 ┱  ┃
┃  3  0x03 │  [END OF TEXT]           ┃  35  0x23 │  #        ┃  67  0x43 │  C  ┃   99   0x63 │ c        ┃ ┃         ┃         ┃         ┃         ┃
┃  4  0x04 │  [END OF TRANSMISSION]   ┃  36  0x24 │  $        ┃  68  0x44 │  D  ┃  100   0x64 │ d        ┃ ┃ 2502 │  ┃ 2512 ┒  ┃ 2522 ┢  ┃ 2532 ┲  ┃
┃  5  0x05 │  [ENQUIRY]               ┃  37  0x25 │  %        ┃  69  0x45 │  E  ┃  101   0x65 │ e        ┃ ┃         ┃         ┃         ┃         ┃
┃  6  0x06 │  [ACKNOWLEDGE]           ┃  38  0x26 │  &        ┃  70  0x46 │  F  ┃  102   0x66 │ f        ┃ ┃ 2503 ┃  ┃ 2513 ┓  ┃ 2523 ┣  ┃ 2533 ┳  ┃
┃  7  0x07 │  [BELL]                  ┃  39  0x27 │  '        ┃  71  0x47 │  G  ┃  103   0x67 │ g        ┃ ┃         ┃         ┃         ┃         ┃
┃  8  0x08 │  [BACKSPACE]             ┃  40  0x28 │  (        ┃  72  0x48 │  H  ┃  104   0x68 │ h        ┃ ┃ 2504 ┄  ┃ 2514 └  ┃ 2524 ┤  ┃ 2534 ┴  ┃
┃  9  0x09 │  [HORIZONTAL TAB]        ┃  41  0x29 │  )        ┃  73  0x49 │  I  ┃  105   0x69 │ i        ┃ ┃         ┃         ┃         ┃         ┃
┃ 10  0x0A │  [LINE FEED]             ┃  42  0x2A │  *        ┃  74  0x4A │  J  ┃  106   0x6A │ j        ┃ ┃ 2505 ┅  ┃ 2515 ┕  ┃ 2525 ┥  ┃ 2535 ┵  ┃
┃ 11  0x0B │  [VERTICAL TAB]          ┃  43  0x2B │  +        ┃  75  0x4B │  K  ┃  107   0x6B │ k        ┃ ┃         ┃         ┃         ┃         ┃
┃ 12  0x0C │  [FORM FEED]             ┃  44  0x2C │  ,        ┃  76  0x4C │  L  ┃  108   0x6C │ l        ┃ ┃ 2506 ┆  ┃ 2516 ┖  ┃ 2526 ┦  ┃ 2536 ┶  ┃
┃ 13  0x0D │  [CARRIAGE RETURN]       ┃  45  0x2D │  -        ┃  77  0x4D │  M  ┃  109   0x6D │ m        ┃ ┃         ┃         ┃         ┃         ┃
┃ 14  0x0E │  [SHIFT OUT]             ┃  46  0x2E │  .        ┃  78  0x4E │  N  ┃  110   0x6E │ n        ┃ ┃ 2507 ┇  ┃ 2517 ┗  ┃ 2527 ┧  ┃ 2537 ┷  ┃
┃ 15  0x0F │  [SHIFT IN]              ┃  47  0x2F │  /        ┃  79  0x4F │  O  ┃  111   0x6F │ o        ┃ ┃         ┃         ┃         ┃         ┃
┃ 16  0x10 │  [DATA LINK ESCAPE]      ┃  48  0x30 │  0        ┃  80  0x50 │  P  ┃  112   0x70 │ p        ┃ ┃ 2508 ┈  ┃ 2518 ┘  ┃ 2528 ┨  ┃ 2538 ┸  ┃
┃ 17  0x11 │  [DEVICE CONTROL 1]      ┃  49  0x31 │  1        ┃  81  0x51 │  Q  ┃  113   0x71 │ q        ┃ ┃         ┃         ┃         ┃         ┃
┃ 18  0x12 │  [DEVICE CONTROL 2]      ┃  50  0x32 │  2        ┃  82  0x52 │  R  ┃  114   0x72 │ r        ┃ ┃ 2509 ┉  ┃ 2519 ┙  ┃ 2529 ┩  ┃ 2539 ┹  ┃
┃ 19  0x13 │  [DEVICE CONTROL 3]      ┃  51  0x33 │  3        ┃  83  0x53 │  S  ┃  115   0x73 │ s        ┃ ┃         ┃         ┃         ┃         ┃
┃ 20  0x14 │  [DEVICE CONTROL 4]      ┃  52  0x34 │  4        ┃  84  0x54 │  T  ┃  116   0x74 │ t        ┃ ┃ 250A ┊  ┃ 251A ┚  ┃ 252A ┪  ┃ 253A ┺  ┃
┃ 21  0x15 │  [NEGATIVE ACKNOWLEDGE]  ┃  53  0x35 │  5        ┃  85  0x55 │  U  ┃  117   0x75 │ u        ┃ ┃         ┃         ┃         ┃         ┃
┃ 22  0x16 │  [SYNCHRONOUS IDLE]      ┃  54  0x36 │  6        ┃  86  0x56 │  V  ┃  118   0x76 │ v        ┃ ┃ 250B ┋  ┃ 251B ┛  ┃ 252B ┫  ┃ 253B ┻  ┃
┃ 23  0x17 │  [ENG OF TRANS. BLOCK]   ┃  55  0x37 │  7        ┃  87  0x57 │  W  ┃  119   0x77 │ w        ┃ ┃         ┃         ┃         ┃         ┃
┃ 24  0x18 │  [CANCEL]                ┃  56  0x38 │  8        ┃  88  0x58 │  X  ┃  120   0x78 │ x        ┃ ┃ 250C ┌  ┃ 251C ├  ┃ 252C ┬  ┃ 253C ┼  ┃
┃ 25  0x19 │  [END OF MEDIUM]         ┃  57  0x39 │  9        ┃  89  0x59 │  Y  ┃  121   0x79 │ y        ┃ ┃         ┃         ┃         ┃         ┃
┃ 26  0x1A │  [SUBSTITUTE]            ┃  58  0x3A │  :        ┃  90  0x5A │  Z  ┃  122   0x7A │ z        ┃ ┃ 250D ┍  ┃ 251D ┝  ┃ 252D ┭  ┃ 253D ┽  ┃
┃ 27  0x1B │  [ESCAPE]                ┃  59  0x3B │  ;        ┃  91  0x5B │  [  ┃  123   0x7B │ {        ┃ ┃         ┃         ┃         ┃         ┃
┃ 28  0x1C │  [FILE SEPARATOR]        ┃  60  0x3C │  <        ┃  92  0x5C │  \  ┃  124   0x7C │ |        ┃ ┃ 250E ┎  ┃ 251E ┞  ┃ 252E ┮  ┃ 253E ┾  ┃
┃ 29  0x1D │  [GROUP SEPARATOR]       ┃  61  0x3D │  =        ┃  93  0x5D │  ]  ┃  125   0x7D │ }        ┃ ┃         ┃         ┃         ┃         ┃
┃ 30  0x1E │  [RECORD SEPARATOR]      ┃  62  0x3E │  >        ┃  94  0x5E │  ^  ┃  126   0x7E │ ~        ┃ ┃ 250F ┏  ┃ 251F ┟  ┃ 252F ┯  ┃ 253F ┿  ┃
┃ 31  0x1F │  [UNIT SEPARATOR]        ┃  63  0x3F │  ?        ┃  95  0x5F │  _  ┃  127   0x7F │ [DELETE] ┃ ┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
┗━━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━┷━━━━━━━━━━━┻━━━━━━━━━━━┷━━━━━┻━━━━━━━━━━━━━┷━━━━━━━━━━┛
]]


charcodes.popup = awful.popup {
    widget = {
        {
            {
                text   = charcodes.table,
                widget = wibox.widget.textbox,
                font = 'Liberation Mono'
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    bg           = '#4040b0',
    border_color = '#00ff00',
    border_width = 5,
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect,
    visible      = false,
    ontop        = true,
}

function charcodes.hidde()
    charcodes.popup.visible = false
end

function charcodes.show()
    charcodes.popup.visible = true
end

function charcodes.toggle()
    if charcodes.popup.visible then
        charcodes.hidde()
    else
        charcodes.show()
    end
end

return charcodes
