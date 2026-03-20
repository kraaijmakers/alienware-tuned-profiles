# Maintainer: Kevin Raaijmakers <kevin@raaijmakers.it>
pkgname=alienware-tuned-profiles
pkgver=1.0.0
pkgrel=1
pkgdesc="Alienware Aurora R12 Tuned Integration"
arch=('any')
url="https://github.com/kraaijmakers/alienware-tuned-profiles"
license=('custom')
install=hardware-check.install
depends=('tuned' 'gamemode' 'acpi_call')
optdepends=('lib32-gamemode: 32-bits gamemode')
backup=(
    'etc/tuned/profiles/balanced/tuned.conf'
    'etc/tuned/profiles/performance/tuned.conf'
    'etc/tuned/profiles/powersave/tuned.conf'
    'etc/gamemode.ini'
)

package() {
    local _profiles=(balanced performance powersave)

    for _profile in "${_profiles[@]}"; do
        install -Dm644 "${startdir}/etc/tuned/profiles/${_profile}/tuned.conf" \
            "${pkgdir}/etc/tuned/profiles/${_profile}/tuned.conf"
        install -Dm755 "${startdir}/etc/tuned/scripts/fan-profile.sh" \
            "${pkgdir}/etc/tuned/profiles/${_profile}/fan-profile.sh"
    done

    install -Dm644 "${startdir}/etc/tuned/ppd.conf" \
        "${pkgdir}/usr/share/${pkgname}/ppd.conf.example"

    install -Dm644 "${startdir}/etc/gamemode.ini" \
        "${pkgdir}/etc/gamemode.ini"
}
