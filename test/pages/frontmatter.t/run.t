When there is no frontmatter, everything is normal

  $ odoc compile zero_frontmatter.mld
  $ odoc_print page-zero_frontmatter.odoc | jq '.frontmatter'
  []

When there is one frontmatter, it is extracted from the content:

  $ odoc compile one_frontmatter.mld
  $ odoc_print page-one_frontmatter.odoc | jq '.frontmatter'
  [
    [
      "bli1",
      " bloblobloblo1"
    ],
    [
      "bli2",
      " bloblobloblo2"
    ]
  ]
  $ odoc_print page-one_frontmatter.odoc | jq '.content'
  [
    {
      "`Heading": [
        {
          "heading_level": "`Title",
          "heading_label_explicit": "false"
        },
        {
          "`Label": [
            {
              "`LeafPage": [
                "None",
                "one_frontmatter"
              ]
            },
            "one-frontmatter"
          ]
        },
        [
          {
            "`Word": "One"
          },
          "`Space",
          {
            "`Word": "frontmatter"
          }
        ]
      ]
    }
  ]

When there is more than one frontmatter, they are all extracted from the content:

  $ odoc compile two_frontmatters.mld
  $ odoc_print page-two_frontmatters.odoc | jq '.frontmatter'
  [
    [
      "bli3",
      " bloblobloblo1"
    ],
    [
      "bli1",
      " bloblobloblo1"
    ],
    [
      "bli2",
      " bloblobloblo2"
    ]
  ]
  $ odoc_print page-two_frontmatters.odoc | jq '.content'
  [
    {
      "`Heading": [
        {
          "heading_level": "`Title",
          "heading_label_explicit": "false"
        },
        {
          "`Label": [
            {
              "`LeafPage": [
                "None",
                "two_frontmatters"
              ]
            },
            "two-frontmatters"
          ]
        },
        [
          {
            "`Word": "Two"
          },
          "`Space",
          {
            "`Word": "frontmatters"
          }
        ]
      ]
    }
  ]
