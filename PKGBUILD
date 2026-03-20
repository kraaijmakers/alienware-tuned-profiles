# Maintainer: Kevin Raaijmakers <kevin@raaijmakers.it>
pkgname=alienware-tuned-profiles
pkgver=1.1.0
pkgrel=1
pkgdesc="Alienware Aurora R12 Tuned Integration"
arch=('any')
url="https://github.com/kraaijmakers/alienware-tuned-profiles"
license=('custom')
install=hardware-check.install
depends=('tuned' 'gamemode')
optdepends=('lib32-gamemode: 32-bit gamemode support')
backup=(
    'etc/tuned/profiles/aw-balanced/tuned.conf'
    'etc/tuned/profiles/aw-performance/tuned.conf'
    'etc/tuned/profiles/aw-powersave/tuned.conf'
    'etc/gamemode.ini'
)

package() {
    local _profiles=(aw-balanced aw-performance aw-powersave)

    for _profile in "${_profiles[@]}"; do
        install -Dm644 "${startdir}/etc/tuned/profiles/${_profile}/tuned.conf" \
            "${pkgdir}/etc/tuned/profiles/${_profile}/tuned.conf"
    done

    install -Dm644 "${startdir}/etc/tuned/ppd.conf" \
        "${pkgdir}/usr/share/${pkgname}/ppd.conf.example"

    install -Dm644 "${startdir}/etc/gamemode.ini" \
        "${pkgdir}/etc/gamemode.ini"
}
