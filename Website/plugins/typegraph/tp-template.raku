%(
    typegraph => sub (%prm, %tml) {
        qq:to/TYPEG/
        <figure>
                <figcaption>Type relations for <code>{ %prm<path> }</code></figcaption>
          { %prm<svg> }
          <p class="fallback">
            <a
              rel="alternate"
              href="/images/type-graph-{ %prm<esc-path> }.svg"
              type="image/svg+xml"
              >Expand above chart</a
            >
          </p>
        </figure>
        TYPEG





    },
)