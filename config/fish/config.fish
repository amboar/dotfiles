if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings

    # Allow hx in schroots
    set -p PATH $HOME/.cargo/bin
    set -p PATH $HOME/.local/bin/ccache
    set -gx EDITOR hx
    set -gx COLORTERM truecolor

    if test -z "$SCHROOT_SESSION_ID"
        direnv hook fish | source

        set -p PATH $HOME/.local/bin

        set -gx BB_NUMBER_THREADS $(math $(nproc) / 4)
        set -gx PARALLEL_MAKE -j$(math $(nproc) / 2)
        set -gx DL_DIR /var/cache/bitbake/downloads
        set -gx SSTATE_DIR /var/cache/bitbake/sstate
        set -gx BB_ENV_PASSTHROUGH_ADDITIONS "DL_DIR SSTATE_DIR"

        set -gx QNET -net nic -net user,hostfwd=:127.0.0.1:2222-:22,hostfwd=:127.0.0.1:2443-:443,hostname=qemu

        set -gx SSH_AUTH_SOCK $(gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent
    end
end
