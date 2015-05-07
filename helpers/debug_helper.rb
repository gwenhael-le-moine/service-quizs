# Pretty display of Hashes
class Hash
  def to_html
    ['<ul>',
     map { |k, v| ["<li><strong>#{k}</strong> : ", v.respond_to?(:to_html) ? v.to_html : "<span>#{v}</span></li>"] },
     '</ul>'
    ].join
  end
end
